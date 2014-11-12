CREATE TABLE [dbo].[Suspensao_Credito] (
    [cd_suspensao_credito] INT          NOT NULL,
    [nm_suspensao_credito] VARCHAR (40) NOT NULL,
    [sg_suspensao_credito] CHAR (10)    NULL,
    [ic_suspensao_credito] CHAR (1)     NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Suspensao_Credito] PRIMARY KEY CLUSTERED ([cd_suspensao_credito] ASC) WITH (FILLFACTOR = 90)
);

