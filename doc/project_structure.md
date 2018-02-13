## Δομή της Εργασίας \& Τρόπος χρήσης
Η εργασία απαρτίζεται από πολλά κομμάτια. Έχουμε το κομμάτι των δεδομένων που βρίσκεται στο φάκελο data και αφορά τις χρονοσειρές που δίνονται για αυτή την εργασία. Παράλληλα δίνουμε και ένα script το οποίο κατεβάζει τις χρονοσειρές. Το κομμάτι της γραπτής αναφοράς βρίσκεται στον φάκελο doc. Τα δεδομένα που εξάγουμε από τις χρονοσειρές βρίσκονται στο φάκελο assets. Όλα τα αρχεία κώδικα βρίσκονται στο φάκελο src. Επιπλέον υπάρχει ο φάκελος kdtree όπου έχει τις βιβλιοθήκες που χρειάζονται για τη μη γραμμική ανάλυση.

Πιο συγκεκριμένα ο τρόπος με τον οποίο καλείται ο κώδικας στη matlab είναι ο εξής:
1. Ο χρήστης χρειάζεται απλά να ορίσει ως αρχική διαδρομή αρχείου τη διαδρομή αρχείου που βρίσκεται η εργασία.
2. Γράφει  `main`  στην κονσόλα.

Το σκριπτάκι main φροντίζει να καλέσει όλα τα υπόλοιπα αρχεία, ώστε να γίνουν όλες οι αναλύσεις. Τέλος όλα τα αποτελέσματα θα γραφούν στον φάκελος assets, διαγράφοντας όλα τα προηγούμενα.

![100](project_struct.png "Ο τρόπος κλήσης αρχείων από τη main")




### Ο κώδικας του αρχείου `main.m`:
```matlab
addpath('src');
addpath('kdtree');
addpath('kdtree/src');
addpath('kdtree/lib');
system('rm assets/*');
clear all;
close all;

%%%%%%%%%%%%%%%% FLAGS %%%%%%%%%%%%%%%%
BASIC_PLOT                      = true;
FIR                             = true;
EXTREMA_PLOT                    = true;
EXTREMA_SERIES_PLOT             = true;
REMOVES_TREND                   = true;
REMOVES_TREND_PLOT              = true;
AUTOCORR_PLOT                   = true;
AKAIKE                          = true;


SCATTER_DIAGRAMS_PLOT           = false;
DBSCAN_CLUSTERING               = false;
FALSE_NEAREST_CALC_PLOT         = true;
FIND_BEST_TAU                   = true;
CALCULATE_CORRELATION_DIMENSION = true;
PLOT_CORR_DIM                   = true;
TRAIN_LOCAL_MODEL               = true;
%%%%%%%%%%%%%%%% Input time Series & globals %%%%%%%%%%%%%%%%
LENGTH                          = 6000;
TEST_SET_LENGTH                 = 500;
POLORDER                        = 4;
MAX_ORDER_AR                    = 20;
MAX_ORDER_MA                    = 3;
fs                              = 100; % Hz
Ts                              = 1.0 / fs; % seconds

% read series
fileID1 = fopen('data/dat6v1.dat', 'r');
fileID2 = fopen('data/dat6v2.dat', 'r');
X1 = cell2mat(textscan(fileID1, '%f'));
X2 = cell2mat(textscan(fileID2, '%f'));
T = [1:LENGTH];


%%%%%%%%%%%%%%%% Time Series 1 %%%%%%%%%%%%%%%%
LINEAR1
NONLINEAR1
%%%%%%%%%%%%%%%% Time Series 2 %%%%%%%%%%%%%%%%
LINEAR2
NONLINEAR2


%%%%%%%%%%%%%%%% auto crop all images %%%%%%%%%
% requires image magic
!mogrify -trim +repage assets/*.png
```