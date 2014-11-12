CREATE TABLE [dbo].[Mensagem_Proposta] (
    [cd_mensagem_proposta]     INT          NOT NULL,
    [nm_mensagem_proposta]     VARCHAR (30) NOT NULL,
    [cd_ordem_msg_proposta]    INT          NOT NULL,
    [ds_obs_mensagem_proposta] TEXT         NULL,
    [ic_ativo_msg_proposta]    CHAR (1)     NOT NULL,
    [ic_moldura_proposta]      CHAR (1)     NULL,
    [ic_negrito_proposta]      CHAR (1)     NULL,
    [ic_grifado_proposta]      CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Mensagem_Proposta] PRIMARY KEY CLUSTERED ([cd_mensagem_proposta] ASC) WITH (FILLFACTOR = 90)
);

