using Colors
using OpenCV
const cv = OpenCV

export  StereoMatcher, StereoBM,
        compute

"""
Base type for all stereo matching algorithms, or
stereo correspondence algorithms.
"""
abstract type StereoMatcher end

"""
Computing stereo correspondence using the block matching algorithm. This is a wrapper
arround the corresponding OpenCV algorithm.
"""
struct StereoBM <: StereoMatcher
   ptr::OpenCV.cv_PtrAllocated{OpenCV.StereoBM} 
   
   function StereoBM(num_disparities::Integer, block_size::Integer)
       new(cv.StereoBM_create(
               numDisparities=Int32(num_disparities), 
               blockSize=Int32(block_size)))
   end
end

"""
     StereoBM(;num_disparities=0, block_size=21)
Creates stereo matching algorithm based on block matching.

- `num_disparities` the disparity search range. For each pixel algorithm will find the best disparity 
   from 0 (default minimum disparity) to `num_disparities`. 
   The search range can then be shifted by changing the minimum disparity.

- `block_size` the linear size of the blocks compared by the algorithm. 
   The size should be odd (as the block is centered at the current pixel). 
   Larger block size implies smoother, though less accurate disparity map. 
   Smaller block size gives more detailed disparity map, 
   but there is higher chance for algorithm to find a wrong correspondence.
"""
function StereoBM(;num_disparities=0, block_size=21)
    StereoBM(num_disparities, block_size)
end

"""
    compute(matcher::StereoMatcher, left::Matrix{T}, right::Matrix{T}) -> right::Matrix{Gray}
    
Performs stereo matching between two images given by `left` and `right` where each element has to be
of a type `T` which is either a color such `Gray` or `RGB` or some kind of floating point of fixed point
type which can represent values between 0 and 1.

We get back a dispartity map, which is 2D matrix of `Gray` values.
"""
function compute(matcher::StereoMatcher, left::Matrix{T}, right::Matrix{T}) where T <: Union{Real, Color}
    imgL = image_to_opencv_input(left)
    imgR = image_to_opencv_input(right) 
    
    disparity = cv.compute(matcher.ptr, imgL, imgR)

    opencv_disparity_map_to_image(disparity)
end