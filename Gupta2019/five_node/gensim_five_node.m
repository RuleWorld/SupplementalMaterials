function [err, sp, obsv] = gensim_five_node(n,params)
%SIMULATE Generate trajectory for Michaelis-Menten
%
%  [err, sp, obsv] = simulate( t, init, params, S0, E0, cfg )
%
%  generate Michaelis-Menten trajectory, where 't' is a vector
%  of time points, with parameters 'params', with initial substrate 'S0',
%  initial enzyme 'S0', and additional configuration arguments 'cfg'.
%
%  If 'init' = [], then default initial conditions are used. Note that
%  initial conditions are with respect to the first time point, not
%  necessarily t=0.  
%
%  Time units are seconds. The state trajectories and observables 
%  have concentration units
%%
t = linspace(0,50,n)';
% run simulation
[err, ~, sp, obsv] = five_node( t, [], params, 1 );
obsv = obsv(:,1);
if (err)
    sp = 1e29*ones(size(t));
    obsv = 1e29*ones(size(t));
    return;
end
return;

