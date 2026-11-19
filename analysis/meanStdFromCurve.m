function [mu, sigma] = meanStdFromCurve(x, y)
% x, y define a curve proportional to a PDF (or any nonnegative density-like curve).
% Works for uneven x spacing using numerical integration.

    x = x(:); y = y(:);

    ok = isfinite(x) & isfinite(y) & (y >= 0);
    x = x(ok); y = y(ok);

    % Sort by x for integration
    [x, idx] = sort(x);
    y = y(idx);

    % Normalize area to 1 (PDF normalization)
    A = trapz(x, y);
    if A <= 0
        error('Curve area is non-positive; cannot interpret as a distribution.');
    end
    p = y / A;  % normalized density

    % Mean: ∫ x p(x) dx
    mu = trapz(x, x .* p);

    % Variance: ∫ (x-mu)^2 p(x) dx
    varx = trapz(x, (x - mu).^2 .* p);
    sigma = sqrt(max(varx, 0));
end




