package org.dasfoo.delern.adapters;

import android.content.Context;

import com.firebase.ui.database.FirebaseRecyclerAdapter;
import com.google.firebase.database.Query;

import org.dasfoo.delern.callbacks.OnDeckViewHolderClick;
import org.dasfoo.delern.models.Deck;
import org.dasfoo.delern.viewholders.DeckViewHolder;

/**
 * Created by katarina on 11/19/16.
 */

public class DeckRecyclerViewAdapter extends FirebaseRecyclerAdapter<Deck, DeckViewHolder> {

    private OnDeckViewHolderClick onDeckViewHolderClick;
    private Context context;
    /**
     * @param modelClass      Firebase will marshall the data at a location into an instance
     *                        of a class that you provide
     * @param modelLayout     This is the layout used to represent a single item in the list.
     *                        You will be responsible for populating an instance of the
     *                        corresponding view with the data from an instance of modelClass.
     * @param viewHolderClass The class that hold references to all sub-views in an instance modelLayout.
     * @param ref             The Firebase location to watch for data changes. Can also be a slice
     *                        of a location, using some
     */
    public DeckRecyclerViewAdapter(Class<Deck> modelClass, int modelLayout, Class<DeckViewHolder> viewHolderClass, Query ref) {
        super(modelClass, modelLayout, viewHolderClass, ref);
    }

    /**
     * Each time the data at the given Firebase location changes, this method will be called for each item that needs
     * to be displayed. The first two arguments correspond to the mLayout and mModelClass given to the constructor of
     * this class. The third argument is the item's position in the list.
     * <p>
     * Your implementation should populate the view using the data contained in the model.
     *
     * @param viewHolder The view to populate
     * @param deck      The object containing the data used to populate the view
     * @param position   The position in the list of the view being populated
     */
    @Override
    protected void populateViewHolder(DeckViewHolder viewHolder, Deck deck, int position) {
        viewHolder.getmDesktopTextView().setText(deck.getName());
        viewHolder.setOnViewClick(onDeckViewHolderClick);
        viewHolder.setContext(context);
    }

    public void setOnDeckViewHolderClick(OnDeckViewHolderClick onDeckViewHolderClick) {
        this.onDeckViewHolderClick = onDeckViewHolderClick;
    }

    public void setContext(Context context) {
        this.context = context;
    }
}
