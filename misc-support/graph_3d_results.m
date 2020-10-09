

innovate_plot_vector=[0 1 2];
observe_plot_vector=[0 1 2];

%low environmental change
%result_matrix=[37.33 672.75 681.43; 188.50 571.68 507.78; 220.67 411.02 308.84]; 

%med environmental change
result_matrix=[330.53 587.27 519.49; 552.64 512.43 266.40; 482.25 260.30 88.69];


%high env change
%result_matrix=[591.19 584.03 402.37; 595.89 443.07 223.67; 460.41 224.88 74.51];



surf(innovate_plot_vector, observe_plot_vector, result_matrix);

