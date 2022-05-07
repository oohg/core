/*
 * $Id: i_color.ch $
 */
/*
 * OOHG source code:
 * Color definitions
 *
 * Copyright 2005-2022 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2022 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2022 Contributors, https://harbour.github.io/
 */
/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file LICENSE.txt. If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1335, USA (or download from http://www.gnu.org/licenses/).
 *
 * As a special exception, the ooHG Project gives permission for
 * additional uses of the text contained in its release of ooHG.
 *
 * The exception is that, if you link the ooHG libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the ooHG library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the ooHG
 * Project under the name ooHG. If you copy code from other
 * ooHG Project or Free Software Foundation releases into a copy of
 * ooHG, as the General Public License permits, the exception does
 * not apply to the code that you add in this way. To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for ooHG, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 */


#define AQUA               {   0, 255, 255 }
#define BLACK              {   0,   0,   0 }
#define BLUE               {   0,   0, 255 }
#define BROWN              { 128,  64,  64 }
#define CYAN               {   0, 255, 255 }
#define FUCHSIA            { 255,   0, 255 }
#define GRAY               { 128, 128, 128 }
#define GREEN              {   0, 255,   0 }
#define LCYAN              { 153, 217, 234 }
#define LGREEN             {   0, 128,   0 }
#define MAGENTA            { 255,   0, 255 }
#define MAROON             { 128,   0,   0 }
#define NAVY               {   0,   0, 128 }
#define OLIVE              { 128, 128,   0 }
#define ORANGE             { 255, 128,  64 }
#define PINK               { 255, 128, 192 }
#define PURPLE             { 128,   0, 128 }
#define RED                { 255,   0,   0 }
#define SILVER             { 192, 192, 192 }
#define TEAL               {   0, 128, 128 }
#define WHITE              { 255, 255, 255 }
#define YELLOW             { 255, 255,   0 }

/* Metro UI Colors */
// Base colors
#define METRO_LIME         { 164, 196,   0 }
#define METRO_GREEN        {  96, 169,  23 }
#define METRO_EMERALD      {   0, 138,   0 }
#define METRO_TEAL         {   0, 171, 169 }
#define METRO_BLUE         {   0, 175, 240 }
#define METRO_CYAN         {  27, 161, 226 }
#define METRO_COBALT       {   0,  80, 239 }
#define METRO_INDIGO       { 106,   0, 255 }
#define METRO_VIOLET       { 170,   0, 255 }
#define METRO_PINK         { 220,  79, 173 }
#define METRO_MAGENTA      { 216,   0, 115 }
#define METRO_CRIMSON      { 162,   0,  37 }
#define METRO_RED          { 206,  53,  44 }
#define METRO_ORANGE       { 250, 104,   0 }
#define METRO_AMBER        { 240, 163,  10 }
#define METRO_YELLOW       { 227, 200,   0 }
#define METRO_BROWN        { 130,  90,  44 }
#define METRO_OLIVE        { 109, 135, 100 }
#define METRO_STEEL        { 100, 118, 135 }
#define METRO_MAUVE        { 118,  96, 138 }
#define METRO_TAUPE        { 135, 121,  78 }
// Dark colors
#define METRO_DARK_BROWN   {  99,  54,  47 }
#define METRO_DARK_CRIMSON { 100,   0,  36 }
#define METRO_DARK_MAGENTA { 129,   0,  60 }
#define METRO_DARK_INDIGO  {  75,   0, 150 }
#define METRO_DARK_CYAN    {  27, 110, 174 }
#define METRO_DARK_COBALT  {   0,  53, 106 }
#define METRO_DARK_TEAL    {   0,  64,  80 }
#define METRO_DARK_EMERALD {   0,  62,   0 }
#define METRO_DARK_GREEN   {  18, 128,  35 }
#define METRO_DARK_ORANGE  { 191,  90,  21 }
#define METRO_DARK_RED     { 154,  22,  22 }
#define METRO_DARK_PINK    { 154,  22,  90 }
#define METRO_DARK_VIOLET  {  87,  22, 154 }
#define METRO_DARK_BLUE    {  22,  73, 154 }
// Light colors
#define METRO_LIGHT_BLUE   {  67, 144, 223 }
#define METRO_LIGHTER_BLUE {   0, 204, 255 }
#define METRO_LIGHT_CYAN   {  89, 205, 226 }
#define METRO_LIGHT_TEAL   {  69, 255, 253 }
#define METRO_LIGHT_GREEN  { 122, 214,  29 }
#define METRO_LIGHT_OLIVE  { 120, 170,  28 }
#define METRO_LIGHT_ORANGE { 255, 193, 148 }
#define METRO_LIGHT_PINK   { 244, 114, 208 }
#define METRO_LIGHT_RED    { 218,  90,  83 }
// Gray colors
#define METRO_BLACK        {   0,   0,   0 }
#define METRO_DARK         {  29,  29,  29 }
#define METRO_GRAY_DARKER  {  34,  34,  34 }
#define METRO_GRAY_DARK    {  51,  51,  51 }
#define METRO_GRAY         {  85,  85,  85 }
#define METRO_GRAY_LIGHT   { 153, 153, 153 }
#define METRO_GRAY_LIGHTER { 238, 238, 238 }
#define METRO_WHITE        { 255, 255, 255 }
