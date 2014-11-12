CREATE TABLE [dbo].[CP_Pessoais] (
    [cpps_Sequencia] INT           NOT NULL,
    [cpps_Data]      SMALLDATETIME NOT NULL,
    [cpps_Valor]     MONEY         NOT NULL,
    [cpps_Descricao] VARCHAR (40)  NOT NULL,
    [cpps_Lock]      ROWVERSION    NOT NULL
);

