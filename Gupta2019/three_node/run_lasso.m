% path to parallel tempering scripts
addpath('/shared2/LabUserFiles/Sanjana_Gupta/Original/ptempest/core/');
% path to supplementary distributions
addpath('/shared2/LabUserFiles/Sanjana_Gupta/Original/ptempest/core/distr/');
nchains = 4;
job = [1e29,1e29]; %dummy job index to initialize file
dlmwrite('jobs_lasso.txt',job,'-append');
for mu = [-10,-8]
    for b = 1%[0.1,0.5,1,5,0.01,0.05]
        job = [mu,b];
        %open job file
        started_jobs = dlmread('jobs_lasso.txt');
        %check if this job has been started already
        [~,index] = ismember(job,started_jobs,'rows');
        if index==0
            dlmwrite('jobs_lasso.txt',job,'-append');
        else
            continue
        end
        for repeat = 1:3
            %% load configuration file
            jobname = ['three_node_withlasso_mu_',num2str(mu),'_b_',num2str(b),'_repeat_',num2str(repeat)];
            cfg = config_lasso(nchains,jobname,mu,b);
            % start parallel tempering
            parallel_tempering(cfg);
        end
    end
end