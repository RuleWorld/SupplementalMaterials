addpath('../lib')
addpath('/shared2/LabUserFiles/Sanjana_Gupta/Original/ptempest/core/');
addpath('/shared2/LabUserFiles/Sanjana_Gupta/Original/ptempest/core/distr/');
addpath('../SingleCellNFkB_pulse');
%%
step = 2e4;
f = figure('units','normalized','outerposition',[0,0,1,0.5]);
c = 1;
repeat_index = 1:2:12;
for trajectory_number = [2,3,4]%2:4    
    mu = -25;
    b = 2;
    num_repeats = length(repeat_index);   
    tmp = cell(1,num_repeats);
    dim = 26;
    LB = 5e4;
    UB = 9.9e5;
    num_pts1 = length(LB:UB);
    par_matrix = zeros(num_pts1,dim,num_repeats);
    % Get first set of repeats
    for repeat = 1:num_repeats
        display(['trajectory_number: ',num2str(trajectory_number),' repeat: ',num2str(repeat)]);
        data = load(['../SingleCellNFkB_pulse/SingleCellNFkB_continue_chain_reduced_model_fixedstart_withlasso_mu_',num2str(mu),'_b_',num2str(b),'_trajectory_',num2str(trajectory_number),'_repeat_',num2str(repeat),'_progress990000.mat']);           
        params = data.params_chain(1,:,LB:UB);
        tmp{repeat} = reshape(params,dim,num_pts1);
        par_matrix(:,:,repeat) = tmp{repeat}';
        for j = LB:step:UB
            subplot(3,4,c);
            params = data.params_chain(1,:,j);
            [err, sp, obsv] = simulate( [],[], params);
            p = plot(obsv,'b','LineWidth',2);
            p.Color(4) = 0.1;
            hold on
            ylim([0.5 3])
        end
    end
    hold on
    errorbar(1:length(data.cfg.data{1}.mean),data.cfg.data{1}.mean,data.cfg.data{1}.stdev,'r','LineWidth',1)
    c=c+1;
    %%
    tmp = 0;
    for j = [24,25,26]
        cfg=data.cfg;
        subplot(3,4,c);c=c+1; 
        params = par_matrix(:,j,:);
        h = histogram(params(:),1000,'EdgeColor','none');
        mxhst = max(h.Values);
        hold on
        if mxhst>tmp
            tmp = mxhst;
            ylim([0 mxhst])
        end
        yl = ylim;
        %plot([mu,mu],yl,'--r','LineWidth',2);
        xlim([cfg.param_defs{j}.min,cfg.param_defs{j}.max])

        l = @(x,b,mu)(1/(2*b))*exp(-abs(x-mu)/b); %laplace equation 
        yl = ylim;
        xlim([cfg.param_defs{j}.min,cfg.param_defs{j}.max])
        mx  = (1/(2*b));
        xl = xlim;
        ll = yl(2)*l(xl(1):0.0005:xl(2),b,mu)/(mx);
        plot(xl(1):0.0005:xl(2),ll,'m','LineWidth',2);
        set(gca,'YTickLabels',[]);
    end
   % fig_print(f,['GroupLasso_trajectory_',num2str(trajectory_number),'.png'],[5000,1000],1,1,'w');
end
toPDF(f,'pdf_figures/nfkb_group_lasso_fit_figure.pdf');







    