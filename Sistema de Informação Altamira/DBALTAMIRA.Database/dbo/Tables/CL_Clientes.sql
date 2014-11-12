CREATE TABLE [dbo].[CL_Clientes] (
    [clNome]     CHAR (30) NOT NULL,
    [clEndereco] CHAR (40) NOT NULL,
    [clBairro]   CHAR (20) NOT NULL,
    [clCidade]   CHAR (20) NOT NULL,
    [clEstado]   CHAR (2)  NOT NULL,
    [clCep]      CHAR (9)  NOT NULL,
    CONSTRAINT [PK_CL_Clientes] PRIMARY KEY NONCLUSTERED ([clNome] ASC) WITH (FILLFACTOR = 90)
);

