﻿CREATE TABLE [dbo].[Motorista] (
    [cd_motorista]             INT           NOT NULL,
    [nm_motorista]             VARCHAR (40)  NULL,
    [nm_fantasia_motorista]    VARCHAR (15)  NULL,
    [cd_veiculo]               INT           NULL,
    [cd_fone_motorista]        VARCHAR (15)  NULL,
    [cd_celular_motorista]     VARCHAR (15)  NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    [cd_cpf_motorista]         VARCHAR (15)  NULL,
    [cd_cnh_motorista]         VARCHAR (15)  NULL,
    [sg_categ_cnh_motorista]   CHAR (5)      NULL,
    [dt_valid_cnh_motorista]   DATETIME      NULL,
    [ic_ativo_motorista]       CHAR (1)      NULL,
    [ic_status_motorista]      CHAR (1)      NULL,
    [nm_foto_motorista]        VARCHAR (100) NULL,
    [ic_contratado_motorista]  CHAR (1)      NULL,
    [dt_habilitacao_motorista] DATETIME      NULL,
    [ds_motorista]             TEXT          NULL,
    [cd_banco]                 INT           NULL,
    [cd_agencia_banco]         INT           NULL,
    [cd_conta_motorista]       VARCHAR (20)  NULL,
    [cd_rg_motorista]          VARCHAR (15)  NULL,
    [nm_endereco]              VARCHAR (50)  NULL,
    [nm_compl_end_motorista]   VARCHAR (30)  NULL,
    [cd_identifica_cep]        INT           NULL,
    [nm_bairro_motorista]      VARCHAR (25)  NULL,
    [cd_pais]                  INT           NULL,
    [cd_estado]                INT           NULL,
    [cd_cidade]                INT           NULL,
    [cd_cep]                   INT           NULL,
    [cd_cep_motorista]         CHAR (9)      NULL,
    [pc_comissao_motorista]    FLOAT (53)    NULL,
    [dt_exped_cnh_motorista]   DATETIME      NULL,
    [nm_exped_cnh_motorista]   VARCHAR (15)  NULL,
    [cd_estado_detran]         INT           NULL,
    CONSTRAINT [PK_Motorista] PRIMARY KEY CLUSTERED ([cd_motorista] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Motorista_Cep] FOREIGN KEY ([cd_cep]) REFERENCES [dbo].[Cep] ([cd_identifica_cep]),
    CONSTRAINT [FK_Motorista_Estado] FOREIGN KEY ([cd_estado_detran]) REFERENCES [dbo].[Estado] ([cd_estado])
);

