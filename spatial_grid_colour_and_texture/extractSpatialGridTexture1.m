function F = extractSpatialGridTexture1(img)
    % Extracts a spatial grid descriptor based on the Edge Orientation Histogram 
    % from each grid cell of the given image.

    gridSize = 4;  % 4x4 grid.

    % Compute the size of each grid cell.
    cellHeight = floor(size(img, 1) / gridSize);
    cellWidth = floor(size(img, 2) / gridSize);

    % Convert the image to grayscale if it's not.
    if size(img, 3) == 3
        img = rgb2gray(img);
    end

    % Initialize descriptor.
    F = [];

    for row = 1:gridSize
        for col = 1:gridSize
            % Extract the current cell.
            cellImg = img((row-1)*cellHeight+1 : row*cellHeight, (col-1)*cellWidth+1 : col*cellWidth);

            % Extract the Edge Orientation Histogram for the current cell.
            H = extractEOH(cellImg);
            
            % Append the histogram to the final descriptor.
            F = [F, H];
        end
    end
end

function F = extractEOH(cellImg)
    % Extracts the Edge Orientation Histogram for a given grid cell

    % Compute gradient using Sobel filter
    [Gx, Gy] = imgradientxy(cellImg, 'Sobel');

    % Compute gradient magnitude and orientation
    [~, orientation] = imgradient(Gx, Gy);

    % Quantize the orientation into bins (e.g., 8 bins for 0-360 degrees)
    num_bins = 8;
    bin_edges = linspace(-180, 180, num_bins+1);
    orientation_bins = discretize(orientation, bin_edges);

    % Compute histogram
    H = histcounts(orientation_bins, bin_edges);

    F = H;
    % Normalize histogram (optional)
   % F = H / sum(H);
end
