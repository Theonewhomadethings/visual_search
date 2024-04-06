% Function for computing average colour feature first for the 4 by 4 grid
function F=extractSpatialGridColour1(img)
    % Extracts a spatial grid descriptor based on average RGB values from the given image.

    gridSize = 4; % 4x4 grid. You can adjust this as needed.

    % Compute the size of each grid cell.
    cellHeight = floor(size(img, 1) / gridSize);
    cellWidth = floor(size(img, 2) / gridSize);

    % Initialize descriptor.
    F = [];

    for row = 1:gridSize
        for col = 1:gridSize
            % Extract the current cell.
            cellImg = img((row-1)*cellHeight+1 : row*cellHeight, (col-1)*cellWidth+1 : col*cellWidth, :);

            % Compute the average RGB value for the cell.
            avgColor = mean(mean(cellImg, 1), 2);

            % Append average color to the final descriptor.
            F = [F, reshape(avgColor, 1, 3)];
        end
    end
end
