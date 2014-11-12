CREATE TABLE [dbo].[Propaganda] (
    [cd_propaganda]          INT          NOT NULL,
    [nm_propaganda]          VARCHAR (30) NOT NULL,
    [ds_propaganda]          TEXT         COLLATE Latin1_General_CI_AS NULL,
    [nm_fantasia_propaganda] CHAR (15)    NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    [ic_ativa_propaganda]    CHAR (1)     NOT NULL,
    CONSTRAINT [PK_Propaganda] PRIMARY KEY CLUSTERED ([cd_propaganda] ASC) WITH (FILLFACTOR = 90)
);

