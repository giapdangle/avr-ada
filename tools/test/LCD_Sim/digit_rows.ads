with Gdk.Pixbuf;    use Gdk.Pixbuf;
--with Gdk.Drawable;  use Gdk.Drawable;
with Gdk.GC;        use Gdk.GC;
--with Gdk.RGB;       use Gdk.RGB;
with GLib;          use GLib;
with Interfaces.C;  use Interfaces.C;
with System;        use System;

package Digit_Rows is

   --
   --  add contrast to the black pixels
   --

   subtype Contrast_Range is Glib.Gint range 0 .. 15;

   type Color_Channel is new Natural range 0 .. 255;

   type Rgb is record
      R : Color_Channel;
      G : Color_Channel;
      B : Color_Channel;
   end record;

   type Color_Array is array (Glib.Gint range <>) of Rgb;

   Contrast_Black : constant Color_Array (Contrast_Range) :=
     ( 0 => (0, 220, 85),
       1 => (0, 205, 79),
       2 => (0, 191, 74),
       3 => (0, 176, 68),
       4 => (0, 161, 62),
       5 => (0, 147, 57),
       6 => (0, 132, 51),
       7 => (0, 117, 45),
       8 => (0, 103, 40),
       9 => (0,  88, 34),
      10 => (0,  73, 28),
      11 => (0,  59, 23),
      12 => (0,  44, 17),
      13 => (0,  29, 11),
      14 => (0,  15,  6),
      15 => (0,   0,  0));

   -------------------------------------------------------------------

   --
   --  fixed values
   --
   X_Size : constant GInt := 16;
   Y_Size : constant GInt := 4;

   type Pixbuf_Image is array (Natural range 0..191) of GUChar;
   pragma Convention (C, Pixbuf_Image);

   subtype Row_Val is Glib.Gint range 0 .. 31;
   type Row_Pixbuf_Image_Array is array (Row_Val) of Pixbuf_Image;

   Pixels : constant Row_Pixbuf_Image_Array :=
     ( 0 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100
         ),
       1 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100
         ),
        2 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100
         ),
       3 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100
         ),
       4 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100
         ),
       5 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100
         ),
       6 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100
         ),
       7 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100
         ),
       8 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100
         ),
       9 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100
         ),
       10 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100
         ),
       11 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100
         ),
       12 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100
         ),
       13 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100
         ),
       14 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100
         ),
       15 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100
         ),
       16 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100
         ),
       17 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100
         ),
       18 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100
         ),
       19 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100
         ),
       20 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100
         ),
       21 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100
         ),
       22 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100
         ),
       23 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100
         ),
       24 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100
         ),
       25 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100
         ),
       26 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100
         ),
       27 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100
         ),
       28 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100
         ),
       29 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,  0,220, 85,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100
         ),
       30 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,220, 85,
              0,220, 85,  0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,220, 85,  0,220, 85,  0,255,100,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,220, 85,  0,220, 85,  0,255,100
         ),
       31 =>
         (    0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,255,100,  0,255,100,  0,255,100,
              0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,255,100,  0,  0,  0,
              0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100,
              0,  0,  0,  0,  0,  0,  0,255,100,  0,  0,  0,  0,  0,  0,
              0,255,100,  0,  0,  0,  0,  0,  0,  0,255,100
         ));



   function Get_Pixbuf (Data       : Pixbuf_Image;
                        Colorspace : Gdk_Colorspace := Colorspace_RGB;
                        Has_Alpha  : GBoolean := 0;
                        Bits       : Int := 8;
                        Width      : Int := Int (X_Size);
                        Height     : Int := Int (Y_Size);
                        Rowstride  : Int := 48;
                        Fn         : Address := Null_Address;
                        Fn_Data    : Address := Null_Address)
         return Gdk_Pixbuf;
   pragma Import (C, Get_Pixbuf, "gdk_pixbuf_new_from_data");

end Digit_Rows;
