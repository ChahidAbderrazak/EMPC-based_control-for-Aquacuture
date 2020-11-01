function dydt = myODE(t, y, ft, f, gt, g)
f = interp1(ft, f, t); % Interpolate the data set (ft, f) at times t
g = interp1(gt, g, t); % Interpolate the data set (gt, g) at times t
dydt = -f.*y + g; % Evalute ODE at times t