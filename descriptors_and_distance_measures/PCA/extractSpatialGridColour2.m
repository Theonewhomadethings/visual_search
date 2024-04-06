function F=extractSpatialGridColour2(img)
    % Extracts a spatial grid descriptor based on RGB histogram values from each grid cell of the given image.

    gridSize = 4;  % 4x4 grid. 
    Q = 4;  % Level of quantization of the RGB space. 

    % Compute the size of each grid cell.
    cellHeight = floor(size(img, 1) / gridSize);
    cellWidth = floor(size(img, 2) / gridSize);

    % Initialize descriptor.
    F = [];

    for row = 1:gridSize
        for col = 1:gridSize
            % Extract the current cell.
            cellImg = img((row-1)*cellHeight+1 : row*cellHeight, (col-1)*cellWidth+1 : col*cellWidth, :);

            % Quantize the RGB values of the cell.
            qimg = double(cellImg);
            qimg = floor(qimg * (Q-1)); % Get values in the range 0 to Q-1.

            % Convert the 3D RGB values into a single value for histogram binning.
            bin = qimg(:,:,1) * Q^2 + qimg(:,:,2) * Q + qimg(:,:,3);

            % Ensure the bin indices are within the correct range.
            if any(bin(:) < 0) || any(bin(:) >= Q^3)
                error('Histogram bin indices out of range.');
            end
            
            % Reshape the 2D binning data into a 1D vector.
            vals = reshape(bin, 1, size(bin, 1)*size(bin, 2));
            
            % Compute the histogram.
            H = histcounts(vals, 0:Q^3);
            
            % Check if the sum of H is zero and handle accordingly.
            if sum(H) == 0
                warning('Sum of histogram bins is zero for image: %s', fname);
                H_normalized = zeros(size(H)); % Or handle in another appropriate way.
            else
                % Normalize the histogram.
                H_normalized = H ./ sum(H);
            end
            
            % Append the histogram to the final descriptor.
            F = [F, H_normalized];
        end
    end
end