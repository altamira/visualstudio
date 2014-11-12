CREATE TYPE [dbo].[tp_telefone]
    FROM VARCHAR (20) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[tp_telefone] TO PUBLIC
    AS [dbo];

