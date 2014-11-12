CREATE TABLE [dbo].[Mensagens_Erro] (
    [cd_mensagens_erro]       INT          NOT NULL,
    [nm_mensagens_erro]       VARCHAR (50) NOT NULL,
    [ds_mesagens_erro]        TEXT         NOT NULL,
    [ds_mensagem_apresentada] TEXT         NOT NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_usuario]              INT          NULL,
    CONSTRAINT [PK_Mensagens_Erro] PRIMARY KEY CLUSTERED ([cd_mensagens_erro] ASC) WITH (FILLFACTOR = 90)
);

