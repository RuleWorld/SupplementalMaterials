% path to parallel tempering scripts
addpath('/shared2/LabUserFiles/Sanjana_Gupta/Original/ptempest/core/');
% path to supplementary distributions
addpath('/shared2/LabUserFiles/Sanjana_Gupta/Original/ptempest/core/distr/');
addpath('/shared2/LabUserFiles/Sanjana_Gupta/LassoManuscript/lib')
addpath('/shared2/LabUserFiles/Sanjana_Gupta/LassoManuscript/lib/aboxplot')
range = 5e4:1e3:9.9e5-1;
e = zeros(2,length(range)*6,3);
h = ones(5,1);
p = ones(5,1);
mu = -25;
b = 2;
repeat = 1;
counter=1;
trajectory_counter=1;
for trajectory_number = 2:4%2:4
    c = 1; 
    energy_tmp = zeros(6,length(range));
    repeat_counter=1;
    for repeat = 1:2:12
        data = load(['../SingleCellNFkB_pulse/SingleCellNFkB_continue_chain_reduced_model_fixedstart_withlasso_mu_',num2str(mu),'_b_',num2str(b),'_trajectory_',num2str(trajectory_number),'_repeat_',num2str(repeat),'_progress990000.mat']);                     
        counter=1;
        
        for i = range
            i
            params = data.params_chain(1,:,i);
            energy_tmp(repeat_counter,counter) = data.energy_chain(1,i) + data.cfg.logpdf_prior_fcn(params);%likelihood(params,data1.cfg); 
            counter=counter+1;
        end
        repeat_counter=repeat_counter+1;
        
    end
    e(2,:,trajectory_counter) = energy_tmp(:);
    %%
    energy_tmp1 = zeros(6,length(range));
    repeat_counter=1;
    for repeat = 2:2:12 
        repeat
        data2 = load(['../SingleCellNFkB_pulse/SingleCellNFkB_continue_chain_wolasso_fixedstart_trajectory_',num2str(trajectory_number),'_repeat_',num2str(repeat),'_progress990000.mat']);
        energy_tmp1(repeat_counter,:) = data2.energy_chain(1,range);
        repeat_counter=repeat_counter+1;
    end
    e(1,:,trajectory_counter) = energy_tmp1(:);
    trajectory_counter = trajectory_counter+1;
    
end
%%
f = figure;aboxplot(e,'OutlierMarker','none');

for i = 1:3
    e1 =e(1,:,i);
    e2 = e(2,:,i);
    
    [p,h] = ranksum(e(1,:,i),e(2,:,i))
    
    if h==1
        [q1 q2 q3 fu1 fl1 ou ol] = quartile(e1);
        [q1 q2 q3 fu2 fl2 ou ol] = quartile(e2);
        hold on
        plot([(i-1)+0.825,(i-1)+1.175],[fu1,fu1]+1.5,'LineWidth',2,'Color',[0.5,0.5,0.5])
        hold on
        plot([(i-1)+0.825,(i-1)+0.825],[fu1+0.2,fu1+1.5],'LineWidth',2,'Color',[0.5,0.5,0.5])
        plot([(i-1)+1.175,(i-1)+1.175],[fu2+0.2,fu1+1.5],'LineWidth',2,'Color',[0.5,0.5,0.5])
        hold on
        scatter((i-1)+0.825+(1.175-0.825)/2,fu1+2.5,150,'*','MarkerEdgeColor',[0.3,0.3,0.3])
    end
end

toPDF(f,'pdf_updated_figures_July23_2019/Figure4c_likelihoodcomparison.pdf')
%toPDF(f,'pdf_figures/Figure4c_likelihoodcomparison.pdf')
%savefig('NFkBErrorFigure','png','-c0','-crop')