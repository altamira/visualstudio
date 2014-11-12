CREATE TABLE [dbo].[FI_Movimentos] (
    [fimo_Sequencia] INT           IDENTITY (1, 1) NOT NULL,
    [fimo_Socio]     CHAR (1)      NOT NULL,
    [fimo_Conta]     CHAR (1)      NOT NULL,
    [fimo_Data]      SMALLDATETIME NOT NULL,
    [fimo_Descricao] VARCHAR (30)  NOT NULL,
    [fimo_Operacao]  CHAR (1)      NOT NULL,
    [fimo_Valor]     MONEY         NOT NULL,
    [fimo_Lock]      BINARY (8)    NULL
);

