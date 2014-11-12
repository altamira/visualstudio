CREATE TABLE [dbo].[Processo_Usinagem] (
    [cd_processo_usinagem] INT          NOT NULL,
    [nm_processo_usinagem] VARCHAR (60) NULL,
    [sg_processo_usinagem] CHAR (15)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Processo_Usinagem] PRIMARY KEY CLUSTERED ([cd_processo_usinagem] ASC) WITH (FILLFACTOR = 90)
);

