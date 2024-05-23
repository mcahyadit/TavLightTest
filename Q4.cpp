/*
    This one is giving me a bit of a concern
    I had handled memory leaks in Warcraft 3 but never in C++ let alone one using OpenTibia
    There is very little documentation I could find online regarding the common practices of preventing memory leaks in OpenTibia
    I am also skeptical about the IOLoginData if it has potential memory leaks, but could not find any clue
    
    For this one, I will focus on the C++ side of memory leak, but that in itself was slightly concerning to me
    In C++, the common practice is to either use delete and declare nullptr on the pointer or use std::unique_ptr
    But when I think about it, using delete on the item and player does not sound right... until I found out that IOLoginDta is basically sql queries
*/

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    //used While loop here to get a better control with "break" compared to using "return"
    Player* player = g_game.getPlayerByName(recipient);
    Item* item = Item::CreateItem(itemId);

    while(true) {
        if (!player) {
            player = new Player(nullptr); //Also slightly concerned about this, is it okay for the player to have a nullptr as its id/name??
            if (!IOLoginData::loadPlayerByName(player, recipient)) {
                break;
            }
        }

        if (!item) {
            break;
        }

        g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

        if (player->isOffline()) {
            IOLoginData::savePlayer(player);
        }

        break;
    }

    delete player;
    player = nullptr;

    delete item;
    item = nullptr;

}