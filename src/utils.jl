export  minmax_normalize,
        opencv_disparity_map_to_image

"Normalize all values in array based on min and max value"
function minmax_normalize(A::AbstractArray)
    min = minimum(A)
    max = maximum(A)
    (A .- min) ./ (max - min)
end

"""
    opencv_disparity_map_to_image(A::AbstractArray) -> Matrix{Gray}

OpenCV algorithms for stereo matching (create 3D image from two 2D images)
outputs grayscale images representing disparity maps. These are 16-bit integers
which represent fixed point numbers. They are encoded such that 16 means  1 and
1 means 1/16.

OpenCV images are tranposed relative to Julia images. In Julia images are column ordered,
while OpenCV is row ordered. That is Julia follows the typical Fortran convention while
OpenCV follows the C convention. This means for a Julia image if you ask for size, then
the first dimension is the  height, and the second is the width.
"""
function opencv_disparity_map_to_image(A::AbstractArray)
	grays = Gray.(minmax_normalize(A))
	img = reshape(grays, size(A, 2), size(A, 3))
	transpose(img)
end


"""
    image_to_opencv_input(img::AbstractMatrix) -> Array{UInt8, 3}
    
For OpenCV Image data is always stored in 3D arrays. The reason is that the color
channel represents a dimension. Thus in OpenCV a 200×300 image with RGB values
will be represented by a 3×200×300 array. If the image was grayscale however it would be
represented by a 1×200×300 array.

However in Julia this is different. The first case would be a 300×200 matrix
of `RBG` values. The type would be `Array{RGB, 2}`. Rows and columns would be transposed because rows
are specifies first for a Julia matrix.

The grayscale image would be a 300×200 matrix as well, except the element type would be `Gray`.
The type would be `Array{Gray, 2}`.

The element type of `img` could be `RGB`, `Gray` or some `Real` value. It doesn't matter
as each element will be converted to `Gray` values anyway.

# Examples
```julia
import OpenCV
import ImageView, Images, FileIO

imgL = FileIO.load("images/L1.jpg");
imgR = FileIO.load("images/R1.jpg");

imgL = image_to_opencv_input(imgL)
imgR = image_to_opencv_input(imgR)    

stereo    = OpenCV.StereoBM_create(numDisparities=Int32(96), blockSize=Int32(15));
disparity = OpenCV.compute(stereo, imgL, imgR);

ImageView.imshow(opencv_disparity_map_to_image(disparity))  
```
"""
function image_to_opencv_input(img::AbstractMatrix)
    h, w = size(img)
    imgᵀ = transpose(img)

    # We don't know whether we got gray scales or RGB pixes, but it doesn't matter
    # as this will convert to grayscale no matter what the input was.
    grays = Gray.(reshape(imgᵀ, 1, w, h))
    opencv_input = round.(UInt8, Float32.(grays) .* 255)
end

