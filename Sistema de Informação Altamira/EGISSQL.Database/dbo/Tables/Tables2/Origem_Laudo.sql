CREATE TABLE [dbo].[Origem_Laudo] (
    [cd_origem_laudo]     INT          NOT NULL,
    [nm_origem_laudo]     VARCHAR (30) NULL,
    [sg_origem_laudo]     CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [ic_pad_origem_laudo] CHAR (1)     NULL,
    [ic_laudo_entrada]    CHAR (1)     NULL,
    CONSTRAINT [PK_Origem_Laudo] PRIMARY KEY CLUSTERED ([cd_origem_laudo] ASC) WITH (FILLFACTOR = 90)
);

