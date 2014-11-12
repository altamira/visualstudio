CREATE TABLE [dbo].[Remocao_Adicional] (
    [cd_remocao_adicional] INT          NOT NULL,
    [nm_remocao_adicional] VARCHAR (40) NULL,
    [sg_remocao_adicional] CHAR (10)    NULL,
    [vl_remocao_adcional]  FLOAT (53)   NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Remocao_Adicional] PRIMARY KEY CLUSTERED ([cd_remocao_adicional] ASC) WITH (FILLFACTOR = 90)
);

