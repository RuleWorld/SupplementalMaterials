function [cfg] = config_lasso(nchains,jobname,mu,b)
%CONFIG configure five node model and parallel tempering options
%
%   [cfg] = config()
%
% Initialize default configuration options 
cfg = init_config_defaults();
%% Parameter definitions (see BNGL model for parameter descriptions) [REQUIRED]
% Available prior distributions:
%   'point'           args: 'value'
%   'uniform'         args: 'min', 'max'
%   'normal',         args: 'mu', 'sigma'
%   'lognormal',      args: 'mu', 'sigma'
%   'laplace',        args: 'mu', 'b'
%   'boundedlaplace', args: 'mu', 'b', 'min', 'max'
%   'beta',           args: 'alpha', 'beta'
%   'exponential',    args: 'mu'
LB = -12;
UB = 3;
cfg.param_defs = { ...
  struct('name','k1','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k2','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k3','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k4','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k5','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k6','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k7','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k8','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k9','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k10','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k11','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k12','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k13','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k14','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k15','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k16','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k17','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k18','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k19','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
  struct('name','k20','prior','boundedlaplace','mu',mu,'b',b,'min',LB,'max',UB),...
};
% initialize parameter distributions
cfg = init_parameter_defs( cfg.param_defs, cfg );
%% Observable definitions [REQUIRED]
%  Set display=0 to disable observable plot during visualization. Set
%  minplot/maxplot to see y-axis bounds in visualization scripts.
%  The 'norm' field should be the name of the observable that is used to
%  normalize the observable (e.g. YP is normalized by YT, the total quantity
%  of Y). Leave this field empty if normalization is not desired.
cfg.obsv_defs = {};
% initialize observable structs
cfg = init_observable_defs( cfg.obsv_defs, cfg );
%% Parallel temperating options
% Defaults are usually ok. Things you may want to change: jobname, nchains,
% parallel, nswaps, adapt_last, energy_init_max, relstep_init.
% See core/init_config_defaults.m for a complete list of config options.
cfg.jobname = jobname;                 % job name, for file input/output
cfg.parallel = 0;                      % parallel? true/false
cfg.maxlabs  = 4;                      % maximum number of labs for parallel computing
cfg.nchains  = nchains;                      % number of chains
cfg.nswaps = 900000;                     % number of chain swaps (=number of saved samples!)
cfg.nsteps = 10;                       % number of steps between chain swaps
cfg.display_status_interval = 500;      % How often to display info
cfg.save_progress_interval = 50000;     % How often to save progress 
cfg.adapt_last = 100000;                 % last adaption step
cfg.energy_init_max = 0.05;             % maximum allowed energy for initialization
cfg.beta_init = 0.6;                   % beta initialization parameter
cfg.relstep_init = 0.01;               % relstep initialization parameter
cfg.max_init_steps = 10000;

%% Load experimental data [REQUIRED].
% The data file should import a cell array called "expt".
% Each cell array contains data for an experiment. It should define
%  the fields 'time', 'mean', 'stdev', 'nsamples' and 'weight'.
%  each array should have dimensions T x O, where T is the number of
%  time points and O is the number of observables, except for 'time'
%  which is is a column vector of length T. Set weight=0 if an observation
%  is missing or hidden (e.g. for future validation).  Missing data may be
%  indicated by NaN (not-a-number).
load five_node;   
% get number of experiments
cfg.nexpt = length(expt);
for d = 1 : cfg.nexpt
    % required fields for evaluating fit
    cfg.data{d}.time = expt{d}.time;
    cfg.data{d}.mean = expt{d}.mean;
    cfg.data{d}.stdev = expt{d}.stdev;
    cfg.data{d}.weight   = expt{d}.weight;
end

%% load default functions
cfg = setup_default_functions( cfg );

%% setup custom function handles
% Define a simulation protocol for each experiment [REQUIRED!]
% pass extra options to the protocol fcn here:
% experiment protocols here:
for d = 1 : cfg.nexpt
    % protocol specific parameters:
    % Experimental protocol function:
    %   prototype: [err,sim,obsv] = @(t,init,params)
    cfg.data{d}.protocol_fcn = @(t,init,params) simulate_five_node(t,init,params);
end

% Energy function [REQUIRED!]
%   prototype: [energy] = @(params)
cfg.energy_fcn = @(params) energy_gaussian(params, cfg);




