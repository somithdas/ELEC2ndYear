//                      for( int i=0; i < 10; i++ ) 
//                      {
//                          int j = i + 1;
//                          while( j < 10 ) 
//                          {
//                               if ( A[j] < A[i] ) 
//                               {
//                                   int tmp = A[i];
//                                   A[i] = A[j];
//                                   A[j] = tmp;
//                               }
//                               j = j + 1;
//                          }
//                      }

//  i -> r0   j -> r1   tmp -> r2     A[] -> r3


                mov r0,#0
                push {r4,r5}
                mov r4,#10
for_loop: 
                cmp r0,r4
                bge exit
                add r1,r0,#1
while_loop:
                cmp r1,r4
                bge for_loop
                str r2,[r3,r0,lsl #2]  //A[i]   //stored in tmp to reduce # of operations
                str r5,[r3,r1,lsl #2]  //A[j]   
                cmp r5,r2
                bge while_loop_end
                ldr r5,[r3,r0,lsl #2]  //switch happens here. lsl #2 (multiple of 4) to find address. 
                ldr r2,[r3,r1,lsl #2]
while_loop_end:
                add r1,r1,#1
                add r0,r0,#1
                B for_loop

exit:           pop  {r4,r5}
//Whatever continues on in the function is brought here


func:  
                push {r4-r11,lr}
                mov r7,#0             //tmp = 0
                mov r8,#0             //i = 0
                mov r5,r0
                mov r6,r1               //moved A,n to different scratch register
for_loop:
                add r8,r8,#4            //i+4
                cmp r8,r6               //r3 < n
                BGE exit                //if i+4 >= n
                //i counter (already incremented by 4 so just need to decrement)
                ldr r4,[r5,r8,lsl #2]   //A[i+4]
                push {r4}               // arm calling convention dictates this much be on stack
                sub r8,r8,#1
                ldr r3,[r5,r8,lsl #2]   //A[i+3]
                sub r8,r8,#1
                ldr r2,[r5,r8,lsl #2]   //A[i+2]
                sub r8,r8,#1
                ldr r1,[r5,r8,lsl #2]   //A[i+1]
                sub r8,r8,#1
                ldr r0,[r5,r8,lsl #2]   //A[i]
                BL g
                add r7,r7,r0            //tmp = tmp + g(...)
                add r8,r8,#1            //i++
                B for_loop              //uncondition branch to for loop (start of for loop checks condition for us already)
exit:           
                mov r0,r7               //tmp to result register (arm convention)
                pop {r4-r11,lr}
                mov pc,lr
                
                







