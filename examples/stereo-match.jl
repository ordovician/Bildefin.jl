using Bildefin

using ImageView, Plots

function show_stereo_match(leftfile::AbstractString, rightfile::AbstractString)
    imgL = load(leftfile)
    imgR = load(rightfile)
    
    stereo = StereoBM(num_disparities=96, block_size=15)
    disparity = compute(stereo, imgL, imgR)
    
    imshow(disparity)
end

"Varity the settings for disparties and block settings"
function plot_multiple_matches(leftfile::AbstractString, rightfile::AbstractString)
    imgL = load(leftfile)
    imgR = load(rightfile)
    
    plots = []
    
    for num_disparities in [45, 96, 128], block_size in [6, 15, 31]
        stereo = StereoBM(num_disparities=96, block_size=15)
        disparity = compute(stereo, imgL, imgR)
        plt = plot(disparity, title="num_disparities=$num_disparities, block_size=$block_size")
        push!(plots, plt)
    end
    plot(plots...)
end


show_stereo_match("images/L1.jpg", "images/R1.jpg")
#plot_multiple_matches("images/L1.jpg", "images/R1.jpg")