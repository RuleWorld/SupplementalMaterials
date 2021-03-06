
% path to parallel tempering scripts
addpath('../../../Original/ptempest/core/');

% path to supplementary distributions
addpath('../../../Original/ptempest/core/distr/');
%%
% path to model-specific files (if not the current directory)
%addpath('~/googlecode/ptempest/examples/michment/');
for repeat = [1,2]
    nchains = 4;
    jobname = ['pa_wo_lasso_repeat_',num2str(repeat)];
    %% load configuration file
    cfg = config_wo_lasso(nchains,jobname);
    % start parallel tempering
    parallel_tempering(cfg);
end
