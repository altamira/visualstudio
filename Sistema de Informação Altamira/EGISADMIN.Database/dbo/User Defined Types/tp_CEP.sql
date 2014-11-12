CREATE TYPE [dbo].[tp_CEP]
    FROM INT NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[tp_CEP] TO PUBLIC
    AS [dbo];

