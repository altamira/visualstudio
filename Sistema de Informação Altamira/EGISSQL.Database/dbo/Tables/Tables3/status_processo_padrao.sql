CREATE TABLE [dbo].[status_processo_padrao] (
    [cd_status_processo_padrao] INT          NOT NULL,
    [nm_status_processo_padrao] VARCHAR (60) NULL,
    [sg_status_processo_padrao] CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_status_processo_padrao] PRIMARY KEY CLUSTERED ([cd_status_processo_padrao] ASC) WITH (FILLFACTOR = 90)
);

