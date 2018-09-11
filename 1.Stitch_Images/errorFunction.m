function residuals = errorFunction(H, homoCoord1, homoCoord2)
    transformedPoints = (homoCoord1 * H)';
    transformedPoints = transformedPoints(1:2,:)./repmat(transformedPoints(3,:),2,1);
    residuals = sum((transformedPoints-homoCoord2(:,1:2)').^2,1);
end