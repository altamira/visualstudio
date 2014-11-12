CREATE TABLE [dbo].[Fmea_Padrao] (
    [cd_fmea_padrao]         INT           NOT NULL,
    [dt_fmea_padrao]         DATETIME      NULL,
    [cd_processo_padrao]     INT           NOT NULL,
    [cd_cliente]             INT           NOT NULL,
    [cd_grupo_fmea]          INT           NOT NULL,
    [cd_usuario_fmea]        INT           NULL,
    [cd_usuario_aprov_fmea]  INT           NULL,
    [nm_doc_fmea_padrao]     VARCHAR (100) NULL,
    [nm_caminho_fmea_padrao] VARCHAR (100) NULL,
    [nm_obs_fmea_padrao]     VARCHAR (40)  NULL,
    [dt_aprov_fmea_padrao]   DATETIME      NULL,
    [dt_lib_fmea_padrao]     DATETIME      NULL,
    [cd_usuario_lib_fmea]    INT           NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    CONSTRAINT [PK_Fmea_Padrao] PRIMARY KEY CLUSTERED ([cd_fmea_padrao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Fmea_Padrao_Grupo_FMEA] FOREIGN KEY ([cd_grupo_fmea]) REFERENCES [dbo].[Grupo_FMEA] ([cd_grupo_fmea])
);

