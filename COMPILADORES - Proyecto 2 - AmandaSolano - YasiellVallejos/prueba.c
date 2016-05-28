int main ( ) {
   int grossSalary , basic , da, ta;

   printf ( " Enter basic salary : " );
   scanf ( " %d " , & basic );

   da = (10 * basic) / 100;
   ta = (12 * basic) / 100;

   grossSalary = basic + da + ta;

   printf("Gross salary : %d", gross_salary);
   return (0);
}
