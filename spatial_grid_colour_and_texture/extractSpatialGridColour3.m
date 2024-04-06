function F=extractSpatialGridColour3(img)
    % Extracts a spatial grid descriptor based on color moments (mean, variance, skewness) 
    % for each color channel (R, G, B) from each grid cell of the given image.

    gridSize = 4;  % 4x4 grid. You can adjust this as needed.

    % Compute the size of each grid cell.
    cellHeight = floor(size(img, 1) / gridSize);
    cellWidth = floor(size(img, 2) / gridSize);

    % Initialize descriptor.
    F = [];

    for row = 1:gridSize
        for col = 1:gridSize
            % Extract the current cell.
            cellImg = img((row-1)*cellHeight+1 : row*cellHeight, (col-1)*cellWidth+1 : col*cellWidth, :);
            
            % Extract and compute the moments for each channel.
            for ch = 1:3
                channelData = double(cellImg(:,:,ch));
                
                % Compute mean
                mu = mean(channelData, 'all');
                
                % Compute variance
                varVal = var(channelData(:));
                
                % Compute standard deviation
                sigma = std(channelData(:));
                
                % Compute skewness manually
                skewVal = mean(((channelData(:) - mu) / sigma).^3);
                
                % Append moments to the descriptor.
                F = [F, mu, varVal, skewVal];
            end
        end
    end
end
