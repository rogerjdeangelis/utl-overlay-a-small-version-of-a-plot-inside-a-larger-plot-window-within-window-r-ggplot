%let pgm=utl-overlay-a-small-version-of-a-plot-inside-a-larger-plot-window-within-window-r-ggplot;

R ggplot overlay a small version of a plot inside a larger plot window within window

github
https://tinyurl.com/y3psyhfs
https://github.com/rogerjdeangelis/utl-overlay-a-small-version-of-a-plot-inside-a-larger-plot-window-within-window-r-ggplot

Output graph
https://tinyurl.com/mrybma3c
https://github.com/rogerjdeangelis/utl-overlay-a-small-version-of-a-plot-inside-a-larger-plot-window-within-window-r-ggplot/blob/main/want.pdf

stackoverflow R
https://tinyurl.com/4ncy4v99
https://stackoverflow.com/questions/77159657/inset-element-from-patchwork-is-flipping-the-inset-upside-down

R uses overlays in a vey elagant way.
This is general code that can be used for any types of graphs.

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
  call streaminit(5431);
  do idx=1 to 100;
    a=round(rand('normal'),.01);
    b=round(rand('normal'),.01);
    c=round(rand('normal'),.01);
    d=round(rand('normal'),.01);
    output;
  end;
  drop idx;
  stop;
run;quit;


/**************************************************************************************************************************/
/*                                                                                                                        */
/* INPUT                                                                                                                  */
/*                                                                                                                        */
/* SD1.HAVE total obs=100                                                                                                 */
/*                                                                                                                        */
/*          OUTER PLOT       INNER PLOT                                                                                  */
/*                                                                                                                        */
/* Obs      A        B        C        D                                                                                  */
/*                                                                                                                        */
/*   1     0.25     1.81     0.41     0.12                                                                                */
/*   2    -0.26    -0.49    -0.61    -2.09                                                                                */
/*   3    -0.47     0.27    -1.10    -0.40                                                                                */
/*   4     0.28     0.89     0.32    -0.46                                                                                */
/*   5    -1.32    -0.17     2.02     0.24                                                                                */
/*  ...                                                                                                                   */
/*  95     1.57     0.99    -1.14     0.13                                                                                */
/*  96     0.82    -0.26     1.12     0.37                                                                                */
/*  97     1.22    -0.43     1.46    -0.55                                                                                */
/*  98    -0.62     0.48    -0.77    -0.10                                                                                */
/*  99    -1.33     0.15    -1.30    -0.19                                                                                */
/* 100     2.52     1.36     0.29     0.21                                                                                */
/*                                                                                                                        */
/*                                                                                                                        */
/*  OUTPUT                                                                                                                */
/*                                                                                                                        */
/*     -3            -2            -1             0             1             2             3                             */
/*   A ++-------------+-------------+-------------+-------------+-------------+-------------+-+                           */
/*     |    -5             0             5                                                    |                           */
/*     | C  -+-------------+-------------+--                                                  |                           */
/*   3 +    |                              |                                                  + 3                         */
/*     | 2.5+            *                 + 2.5                                              |                           */
/*     |    |          *  ***              |                                                  |                           */
/*     |    |          ****** ** *         |                     *   *                        |                           */
/*     |    |            *********         |                                                  |                           */
/*     | 0.0+         ***********          + 0.0                                  *           |                           */
/*   2 +    |        ***  *****  *         |                                                  + 2                         */
/*     |    |         *   ****             |                         * *                      |                           */
/*     |    |               **             |                                                  |                           */
/*     |-2.5+            * *     *         +-2.5     ** *   * * *              *              |                           */
/*     |    |                              |                                                  |                           */
/*     |    |                              |        *   B     *                               |                           */
/*   1 +    |                              |                                                  + 1                         */
/*     |-5.0+                              +-5.0        * *  *                                |                           */
/*     |    |                              |         *                 *         *            |                           */
/*     |    -+-------------+-------------+--     *          **   *    *            * *        |                           */
/*     |    -5             0             5                               *                    |                           */
/*     |                   D                      *                                           |                           */
/*   0 +                                                            *  *      *   *           + 0                         */
/*     |                *                       *       *                                     |                           */
/*     |                          * * *    *      ** * *          *                           |                           */
/*     |           A             *                    B                  *                    |                           */
/*     |                                    *        *   B*   *                               |                           */
/*     |                                           *     B                                    |                           */
/*  -1 +                                                   *        *                         + -1                        */
/*     |                    *   *                 *     *         *                           |                           */
/*     |                                        *   *                                         |                           */
/*     |                        *       * *      * **                                         |                           */
/*     |                          *     *                                                     |                           */
/*     |                                   *                                                  |                           */
/*  -2   +                                                                                    + -2                        */
/*     |                                                                                      |                           */
/*     ++-------------+-------------+-------------+-------------+-------------+-------------+-+                           */
/*     -3            -2            -1             0             1             2             3                             */
/*                                                                                                                        */
/*                                                                                                                        */
/*  options ls=90  ps=44;                                                                                                 */
/*  proc plot data=sd1.have;                                                                                              */
/*   plot a*b / box;                                                                                                      */
/*  run;quit;                                                                                                             */
/*                                                                                                                        */
/*  options ls=64 ps=24;                                                                                                  */
/*  proc plot data=sd1.have(rename=c=c123456789012345678901234567890);                                                    */
/*   plot c123456789012345678901234567890*d='*' / box;                                                                    */
/*  run;quit;                                                                                                             */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

%utlfkil(d:/pdf/want.pdf);

%utl_submit_wps64x('

libname sd1 "d:/sd1";

proc r;
export data=sd1.have r=have;
submit;
library("ggplot2");
library("patchwork");

plot1 <- ggplot(have, aes(x = A, y = B)) +
  geom_point();

plot2 <- ggplot(have, aes(x = C, y = D)) +
  geom_point();

inset <- inset_element(
  plot1,
  left = 0.7,
  bottom = 0.7,
  right = 1,
  top = 1
);

pdf("d:/pdf/want.pdf");
plot2 + inset;
pdf();
endsubmit;
');

Output graph
https://tinyurl.com/mrybma3c
https://github.com/rogerjdeangelis/utl-overlay-a-small-version-of-a-plot-inside-a-larger-plot-window-within-window-r-ggplot/blob/main/want.pdf


/**************************************************************************************************************************/
/*                                                                                                                        */
/*     -3            -2            -1             0             1             2             3                             */
/*   A ++-------------+-------------+-------------+-------------+-------------+-------------+-+                           */
/*     |    -5             0             5                                                    |                           */
/*     | C  -+-------------+-------------+--                                                  |                           */
/*   3 +    |                              |                                                  + 3                         */
/*     | 2.5+            *                 + 2.5                                              |                           */
/*     |    |          *  ***              |                                                  |                           */
/*     |    |          ****** ** *         |                     *   *                        |                           */
/*     |    |            *********         |                                                  |                           */
/*     | 0.0+         ***********          + 0.0                                  *           |                           */
/*   2 +    |        ***  *****  *         |                                                  + 2                         */
/*     |    |         *   ****             |                         * *                      |                           */
/*     |    |               **             |                                                  |                           */
/*     |-2.5+            * *     *         +-2.5     ** *   * * *              *              |                           */
/*     |    |                              |                                                  |                           */
/*     |    |                              |        *   B     *                               |                           */
/*   1 +    |                              |                                                  + 1                         */
/*     |-5.0+                              +-5.0        * *  *                                |                           */
/*     |    |                              |         *                 *         *            |                           */
/*     |    -+-------------+-------------+--     *          **   *    *            * *        |                           */
/*     |    -5             0             5                               *                    |                           */
/*     |                   D                      *                                           |                           */
/*   0 +                                                            *  *      *   *           + 0                         */
/*     |                *                       *       *                                     |                           */
/*     |                          * * *    *      ** * *          *                           |                           */
/*     |           A             *                    B                  *                    |                           */
/*     |                                    *        *   B*   *                               |                           */
/*     |                                           *     B                                    |                           */
/*  -1 +                                                   *        *                         + -1                        */
/*     |                    *   *                 *     *         *                           |                           */
/*     |                                        *   *                                         |                           */
/*     |                        *       * *      * **                                         |                           */
/*     |                          *     *                                                     |                           */
/*     |                                   *                                                  |                           */
/*  -2   +                                                                                    + -2                        */
/*     |                                                                                      |                           */
/*     ++-------------+-------------+-------------+-------------+-------------+-------------+-+                           */
/*     -3            -2            -1             0             1             2             3                             */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
