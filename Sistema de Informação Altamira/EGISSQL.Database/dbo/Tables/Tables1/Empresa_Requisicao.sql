CREATE TABLE [dbo].[Empresa_Requisicao] (
    [cd_empresa]                INT      NOT NULL,
    [cd_requisicao_empresa]     INT      NOT NULL,
    [ic_site_empresa_req]       CHAR (1) NULL,
    [ic_endereco_empresa_req]   CHAR (1) NULL,
    [ic_email_empresa_req]      CHAR (1) NULL,
    [ic_iest_empresa_req]       CHAR (1) NULL,
    [ic_cnpj_empresa_req]       CHAR (1) NULL,
    [ic_logotipo_empresa_req]   CHAR (1) NULL,
    [ds_obs_empresa_req]        TEXT     NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    [ic_plano_comp_obrigatorio] CHAR (1) NULL,
    [ic_destinacao_obrigatorio] CHAR (1) NULL,
    [ic_aplicacao_obrigatorio]  CHAR (1) NULL,
    [ic_motivo_obrigatorio]     CHAR (1) NULL,
    [ic_tipo_req_obrigatorio]   CHAR (1) NULL,
    CONSTRAINT [PK_Empresa_Requisicao] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_requisicao_empresa] ASC) WITH (FILLFACTOR = 90)
);

