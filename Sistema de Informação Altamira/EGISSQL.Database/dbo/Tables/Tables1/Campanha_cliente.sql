CREATE TABLE [dbo].[Campanha_cliente] (
    [cd_campanha]               INT           NULL,
    [nm_fantasia_cliente]       VARCHAR (15)  NOT NULL,
    [cd_item_campanha_cliente]  INT           IDENTITY (1, 1) NOT NULL,
    [cd_contato]                INT           NULL,
    [cd_cliente_internet]       INT           NULL,
    [nm_email_cliente_campanha] VARCHAR (100) NULL,
    [cd_fax_cliente_campanha]   VARCHAR (15)  NULL,
    [cd_tel_cliente_campanha]   VARCHAR (15)  NULL,
    [cd_campanha_mensagem]      INT           NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NOT NULL,
    [nm_contato]                VARCHAR (40)  NULL,
    [cd_cliente]                INT           NULL
);

