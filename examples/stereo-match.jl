using Bildefin

using ImageView

function show_stereo_match(leftfile::AbstractString, rightfile::AbstractString)
    imgL = load(leftfile)
    imgR = load(rightfile)
    
    stereo = StereoBM(num_disparities=96, block_size=15)
    disparity = compute(stereo, imgL, imgR)
    
    imshow(disparity)
end

show_stereo_match("images/L1.jpg", "images/R1.jpg")