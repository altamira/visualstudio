CREATE TABLE [dbo].[APC_Neutral] (
    [cd_controle]      INT        NOT NULL,
    [dt_base]          DATETIME   NULL,
    [vl_total_neutral] FLOAT (53) NULL,
    [cd_usuario]       INT        NULL,
    [dt_usuario]       DATETIME   NULL,
    CONSTRAINT [PK_APC_Neutral] PRIMARY KEY CLUSTERED ([cd_controle] ASC)
);

