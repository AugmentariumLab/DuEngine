#pragma once
/**
 * DuRenderer is a basic OpenGL-based renderer which implements most of the
 * ShaderToy functionality Ruofei Du | Augmentarium Lab | UMIACS Computer
 * Science Department | University of Maryland, College Park me [at] duruofei
 * [dot] com 12/6/2017
 */
#include "Texture2D.h"

class TextureFont : public Texture2D {
 public:
  TextureFont(TextureFilter filter, TextureWarp warp);
};
