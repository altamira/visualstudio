CREATE TYPE [dbo].[tp_CGC]
    FROM CHAR (14) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[tp_CGC] TO PUBLIC
    AS [dbo];

