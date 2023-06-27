-- This procedure is for Amount transfer using account number of banks and has been refined to detect low balance or account permissions. 

create or replace PROCEDURE MAKE_TRANSACTION(AMOUNT NUMBER,
                                                DEBIT_ACC IN ACCOUNTS.ACCOUNT_NO%TYPE,
                                                CREDIT_ACC IN ACCOUNTS.ACCOUNT_NO%TYPE) AS
    invalid_input exception;
    D_ACC_NO NUMBER;
    C_ACC_NO NUMBER;
    N_TRANSACTION_ID NUMBER;
    V_AMOUNT NUMBER;
    
BEGIN
    
    SELECT ACCOUNT_NO INTO D_ACC_NO FROM ACCOUNTS WHERE ACCOUNT_NO = DEBIT_ACC;
    SELECT ACCOUNT_NO INTO C_ACC_NO FROM ACCOUNTS WHERE ACCOUNT_NO = CREDIT_ACC;
    SELECT ACCOUNT_BALANCE INTO V_AMOUNT FROM ACCOUNTS WHERE ACCOUNT_NO = DEBIT_ACC;
    SELECT MAX(TRANSACTION_ID)+1 INTO N_TRANSACTION_ID FROM TRANSACTION;
    if AMOUNT > V_AMOUNT
        or DEBIT_ACC != D_ACC_NO
        or CREDIT_ACC != C_ACC_NO
    then
        raise invalid_input;
    end if;
    
    insert into transaction values(N_TRANSACTION_ID, 
                                    AMOUNT,
                                    'Bank Transfer',
                                    sysdate,
                                    null,
                                    DEBIT_ACC,
                                    CREDIT_ACC);
    update accounts set account_balance = account_balance - amount where account_no = debit_acc;
    update accounts set account_balance = account_balance + amount where account_no = credit_acc;
    commit;
    

EXCEPTION
  when invalid_input
  then 
    dbms_output.put_line('Please put Correct Inputs');
END MAKE_TRANSACTION;
