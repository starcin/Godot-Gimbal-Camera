# Godot-Gimbal-Camera
A gimbal camera that can rotate around clicked point.

A video tutorial can be found here:
https://youtu.be/vvZ9b8ZcVZ8

Most of the 3D manipulation software has a checkbox somewhere in their UI that can enable to rotate their camera around the selected object. Without this capability, sometimes it is hard for the user to rotate and pan and zoom until the intended result is achieved.

In Godot, you can send raycasts from the camera and use the hitpoint as the center of the rotation axes (both for vertical and horizontal).
I also showed how to pan the camera while holding the Shift key and zoom by mouse scroll.
