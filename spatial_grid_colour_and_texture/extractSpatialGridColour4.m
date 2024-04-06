function F = extractSpatialGridColour4(img)
    % Extracts a spatial grid descriptor combining average RGB values, color histogram, 
    % and color moments from the given image for each grid cell.

    gridSize = 4;  % 4x4 grid. Adjust as needed.

    % Compute the size of each grid cell.
    cellHeight = floor(size(img, 1) / gridSize);
    cellWidth = floor(size(img, 2) / gridSize);

    Q = 4; % Level of quantization for histogram computation.

    % Initialize descriptor.
    F = [];

    for row = 1:gridSize
        for col = 1:gridSize
            % Extract the current cell.
            cellImg = img((row-1)*cellHeight+1 : row*cellHeight, (col-1)*cellWidth+1 : col*cellWidth, :);
            
            % --- Average Color Feature ---
            avgColor = mean(mean(cellImg, 1), 2);
            F = [F, reshape(avgColor, 1, 3)];
            
            % --- Color Histogram Feature ---
            qimg = double(cellImg);
            qimg = floor(qimg * Q);
            bin = qimg(:,:,1) * Q^2 + qimg(:,:,2) * Q + qimg(:,:,3);
            vals = reshape(bin, 1, size(bin, 1)*size(bin, 2));
            H = histcounts(vals, 0:Q^3);
            F = [F, H./sum(H)];  % Normalize the histogram before adding to descriptor
            
            % --- Color Moments Feature ---
            for ch = 1:3
                channelData = double(cellImg(:,:,ch));
                mu = mean(channelData, 'all');
                sigma = std(channelData(:));
                centeredData = (channelData - mu) ./ sigma;
                skewVal = mean(centeredData(:).^3);  % Manual computation of skewness
            
                varVal = var(channelData(:));
            
                F = [F, mu, varVal, skewVal];
            end

        end
    end
end
