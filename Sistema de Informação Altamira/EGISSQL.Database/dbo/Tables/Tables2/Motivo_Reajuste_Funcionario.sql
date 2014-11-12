CREATE TABLE [dbo].[Motivo_Reajuste_Funcionario] (
    [cd_motivo_reajuste_func] INT          NOT NULL,
    [nm_motivo_reajuste_func] VARCHAR (40) NULL,
    [sg_motivo_reajuste_func] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Reajuste_Funcionario] PRIMARY KEY CLUSTERED ([cd_motivo_reajuste_func] ASC) WITH (FILLFACTOR = 90)
);

