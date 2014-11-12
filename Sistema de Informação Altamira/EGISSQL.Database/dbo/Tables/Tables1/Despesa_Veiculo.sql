CREATE TABLE [dbo].[Despesa_Veiculo] (
    [cd_despesa_veiculo] INT          NOT NULL,
    [nm_despesa_veiculo] VARCHAR (40) NULL,
    [sg_despesa_veiculo] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Despesa_Veiculo] PRIMARY KEY CLUSTERED ([cd_despesa_veiculo] ASC) WITH (FILLFACTOR = 90)
);

