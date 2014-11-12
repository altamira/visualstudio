CREATE TABLE [dbo].[Consulta_Revisao] (
    [cd_consulta_revisao]      INT           NOT NULL,
    [dt_consulta_revisao]      DATETIME      NULL,
    [cd_vendedor]              INT           NULL,
    [cd_consulta]              INT           NULL,
    [cd_tipo_revisao_consulta] INT           NULL,
    [nm_consulta_revisao]      VARCHAR (60)  NULL,
    [ds_consulta_revisao]      TEXT          NULL,
    [nm_obs_consulta_revisao]  VARCHAR (40)  NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    [cd_ref_consulta_revisao]  VARCHAR (15)  NULL,
    [nm_documento_revisao]     VARCHAR (150) NULL,
    CONSTRAINT [PK_Consulta_Revisao] PRIMARY KEY CLUSTERED ([cd_consulta_revisao] ASC) WITH (FILLFACTOR = 90)
);

