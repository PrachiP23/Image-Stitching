function residuals = errorFunction(H, homoCoord1, homoCoord2)

    N= size(homoCoord1,1);
    L = (H*[homoCoord1 ones(N,1)]')';
    L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
    pt_line_dist = sum(L .* [homoCoord2 ones(N,1)],2);
    residuals = abs(pt_line_dist);
    
end