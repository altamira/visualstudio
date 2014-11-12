CREATE TABLE [dbo].[Forma_Entrega] (
    [cd_forma_entrega]     INT          NOT NULL,
    [nm_forma_entrega]     VARCHAR (30) NOT NULL,
    [sg_forma_entrega]     CHAR (10)    NOT NULL,
    [cd_usuario]           INT          NOT NULL,
    [dt_usuario]           DATETIME     NOT NULL,
    [ic_pad_forma_entrega] CHAR (1)     NULL,
    CONSTRAINT [PK_Forma_Entrega] PRIMARY KEY CLUSTERED ([cd_forma_entrega] ASC) WITH (FILLFACTOR = 90)
);

