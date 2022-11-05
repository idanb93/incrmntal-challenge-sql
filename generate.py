import dataclasses
import typing as ty
import random as rn
import textwrap as tw
import uuid

rn.seed(4711337)


def lst(x: str) -> ty.List[str]:
    return [ln.strip() for ln in x.split('\n') if ln.strip()]


words = lst("""
auspratchaus
linegartoks
weepeggle
climpower
surfewed
cheilith
payellards
wilkomp
subsetripting
nedril
justaled
prograken
hasle
galition
compution
coatord
cremensasses
tribepop
storsed
ezocholon
ankelers
toogit
opectionners
ovistshing
innishoverg
rivas
litifactrones
vuel
yelb
emented
comforists
prosiosy
gradhees
cleoniclosel
chanscan
forciner
inefulnessalle
bithe
lonstrian
esuyp
ignibly
uncompersick
eropt
guinsters
spinathitches
skattrandpoint
catermich
ensalex
gaspiralyzing
experb
wethosted
vanchr
canorting
tribepop
spirmarvily
ichy
recepteds
brends
jions
uwilt
colbt
siopp
winfirn
mustanslidly
posideons
unreasto
gramushed
radifightfal
idianly
millimentest
heark
gozi
houshia
oshu
audiolect
aversonines
psycless
autigametablan
variskys
declain
wortibutiously
natearpnoty
relity
naxet
textbols
uwerz
acirassi
ounters
halentecks
kiraric
minooddy
recepteds
cizzbor
brarter
wefly
hygienevangelist
expaing
duraters
alizer
handusnervishm
fantabulous
osevile
yostopholskia
faminoces
jawel
badete
manismanches
tunf
animepolis
shida
""")

customers = lst("""
e83c7beb-e3d2-45e6-8879-37b608b79da5
57a2df4d-a3f6-4bdd-9e3f-5fe0b0959e6f
5e5383aa-849a-43d3-9c46-d23c6f992b53
27155a2c-74a1-4cd6-b00e-909914542fc9
""")

dimensions = lst("""
3b1ebffa-c498-4c59-bd71-0209eb095666
b84b5448-4d2a-49e0-874d-680457b3d8c5
02cb506a-0ee4-4020-bbdd-aaff38c70ee9
98f4b4c3-ef42-4da4-942f-1e66a93e63b2
1f70830f-8fb9-4218-a127-1e99fa13bfd2
""")

metrics = list("""
42880ff4-5617-491f-a835-420aaa17af30
244368bb-d8b5-4dc8-b8a6-72c60cbb3828
6ec7126e-7b32-469c-a1f6-10fb1eb0f0b2
a9f98f30-510a-4f91-b5c9-59ebe7cb51a5
""")


# noinspection PyDefaultArgument
def random_name(state=dict()) -> ty.Tuple[str, str]:
    if 'counter' not in state:
        state['counter'] = 0
    state['counter'] += 1
    name = ' '.join(words[rn.randrange(0, len(words))].capitalize() for _ in range(rn.randint(2, 4)))
    return name, f"{name} (#{state['counter']})".lower()


@dataclasses.dataclass
class Item:
    id: str
    name: str
    parent: ty.Optional[str] = None


def main():
    with open("out.sql", 'w') as f:
        def emit(s):
            f.write(tw.dedent(s).strip())
            f.write('\n')

        def head(s):
            f.write(f"\n-- {s}\n\n")

        no_level_3_customer_ix = rn.randrange(0, len(customers))
        for customer in customers:
            head(f"items for {customer}")
            emit(f"""
                insert into item (customer_id, parent_item_id, item_id, display_name, full_name) values
                ('{customer}', uuid_nil(), uuid_nil(), '', '')
            """)
            max_level_1 = rn.randint(10, 20)
            max_level_2 = rn.randint(20, 40)
            max_level_3 = rn.randint(2, 10) if customer != customers[no_level_3_customer_ix] else 0
            max_level_4 = rn.randint(0, 4)
            items1 = []
            # level 1
            for i in range(max_level_1):
                name, full_name = random_name()
                uid = str(uuid.uuid5(uuid.UUID(customer), full_name)).lower()
                items1.append(Item(id=uid, name=full_name))
                emit(f",('{customer}', uuid_nil(), '{uid}', '{name}', '{full_name}')")
            # level 2
            items2 = []
            for item in items1:
                for i in range(rn.randint(0, max_level_2)):
                    name, full_name = random_name()
                    uid = str(uuid.uuid5(uuid.UUID(customer), full_name)).lower()
                    items2.append(Item(id=uid, name=full_name, parent=item.id))
                    emit(f",('{customer}', '{item.id}', '{uid}', '{name}', '{full_name}')")
            if max_level_3:
                # level 3
                items3 = []
                for item in items2:
                    for i in range(rn.randint(0, max_level_3)):
                        name, full_name = random_name()
                        uid = str(uuid.uuid5(uuid.UUID(customer), full_name)).lower()
                        items3.append(Item(id=uid, name=full_name, parent=item.id))
                        emit(f",('{customer}', '{item.id}', '{uid}', '{name}', '{full_name}')")
                # level 4
                items4 = []
                for item in items3:
                    for i in range(rn.randint(0, max_level_4)):
                        name, full_name = random_name()
                        uid = str(uuid.uuid5(uuid.UUID(customer), full_name)).lower()
                        items4.append(Item(id=uid, name=full_name, parent=item.id))
                        emit(f",('{customer}', '{item.id}', '{uid}', '{name}', '{full_name}')")
            emit(';')


if __name__ == '__main__':
    main()
