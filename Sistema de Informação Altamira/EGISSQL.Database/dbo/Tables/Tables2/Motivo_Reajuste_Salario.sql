CREATE TABLE [dbo].[Motivo_Reajuste_Salario] (
    [cd_motivo_reajuste] INT          NOT NULL,
    [nm_motivo_reajuste] VARCHAR (40) NULL,
    [sg_motivo_reajuste] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Reajuste_Salario] PRIMARY KEY CLUSTERED ([cd_motivo_reajuste] ASC) WITH (FILLFACTOR = 90)
);

