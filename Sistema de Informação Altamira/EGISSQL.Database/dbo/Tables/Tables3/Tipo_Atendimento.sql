CREATE TABLE [dbo].[Tipo_Atendimento] (
    [cd_tipo_atendimento]     INT          NOT NULL,
    [nm_tipo_atendimento]     VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [sg_tipo_atendimento]     CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    [nm_form_atendimento]     VARCHAR (40) NULL,
    [cd_classe]               INT          NULL,
    [ic_pad_tipo_atendimento] CHAR (1)     NULL,
    [ic_mostra_assinatura]    CHAR (1)     NULL,
    [ic_tipo_atendimento]     CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Atendimento] PRIMARY KEY CLUSTERED ([cd_tipo_atendimento] ASC) WITH (FILLFACTOR = 90)
);

